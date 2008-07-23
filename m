Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbYGWW2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbYGWW2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 18:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbYGWW2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 18:28:17 -0400
Received: from gw.goop.org ([64.81.55.164]:39123 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174AbYGWW2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 18:28:17 -0400
Message-ID: <4887B07D.4080000@goop.org>
Date: Wed, 23 Jul 2008 15:28:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: ftrace: eh?
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/trace/trace.c:s_next():

	if (last_ent && !ent)
		seq_puts(m, "\n\nvim:ft=help\n");

eh?

	J

