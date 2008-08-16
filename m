Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbYHPXgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbYHPXgF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 19:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbYHPXfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 19:35:55 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:48615 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbYHPXfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 19:35:54 -0400
Date: Sun, 17 Aug 2008 00:36:15 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [Bug #11237] corrupt PMD after resume
In-Reply-To: <sNRO-BDDjQL.A.xjG.5bzpIB@albercik>
Message-ID: <Pine.LNX.4.64.0808170033330.25704@blonde.site>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik> <sNRO-BDDjQL.A.xjG.5bzpIB@albercik>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2008, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11237
> Subject		: corrupt PMD after resume
> Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Date		: 2008-08-02 9:51 (15 days old)
> References	: http://marc.info/?l=linux-kernel&m=121767073424952&w=4
> Handled-By	: Hugh Dickins <hugh@veritas.com>

Definitely should still be listed: Alan has verified it still happens
with -rc3.  I keep on going back to look at the info he's sent, to
try and work out what might be happening and what to try next.

Hugh
