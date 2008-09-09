Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbYIIX3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbYIIX3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 19:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbYIIX3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 19:29:46 -0400
Received: from gw.goop.org ([64.81.55.164]:56901 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbYIIX3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 19:29:46 -0400
Message-ID: <48C706E8.4020200@goop.org>
Date: Tue, 09 Sep 2008 16:29:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: alex.nixon@citrix.com, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 2/2] xen: fix pinning when not using split pte locks
References: <1220959508-13806-1-git-send-email-alex.nixon@citrix.com>	<48C6BB00.9040607@goop.org>	<48C6CCD7.8030800@citrix.com>	<48C6DE6E.1070804@goop.org>	<48C6F80E.8010509@citrix.com>	<48C6FC0D.9040009@goop.org> <20080909155306.921d453b.akpm@linux-foundation.org>
In-Reply-To: <20080909155306.921d453b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> What are the effects of the bug which you fixed?
>
> Do you consider this to be 2.6.27 material?  2.6.26.x?  2.6.25.x?
>   

This is a fix for a bug which only exists in tip.git.

    J
