Return-Path: <linux-kernel-owner+w=401wt.eu-S1751073AbXA2LGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073AbXA2LGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 06:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbXA2LGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 06:06:40 -0500
Received: from ns1.suse.de ([195.135.220.2]:51200 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbXA2LGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 06:06:39 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: linux-kernel@vger.kernel.org
Subject: question on resume()
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Disposition: inline
Date: Mon, 29 Jan 2007 12:06:39 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200701291206.39637.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

may a driver call wake_up() while doing resume() ?

	Regards
		Oliver
