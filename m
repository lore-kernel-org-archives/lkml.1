Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbZKCVSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbZKCVSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 16:18:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbZKCVSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 16:18:13 -0500
Received: from relay2.sgi.com ([192.48.179.30]:53322 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752029AbZKCVSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 16:18:13 -0500
Message-ID: <4AF09E19.2040405@sgi.com>
Date: Tue, 03 Nov 2009 13:18:17 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: uv12/13
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



It looks like uv12/13 is overflowing it's kernel log buffer.  You might
want to add something like "log_buf_len=16M" to your elilo.conf entry.
I'll edit the one on uv13.

Cheers,
Mike

