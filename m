Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbYHQMPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbYHQMPo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 08:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYHQMPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 08:15:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39718 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbYHQMPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 08:15:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: [Bug #11237] corrupt PMD after resume
Date: Sun, 17 Aug 2008 14:18:57 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik> <sNRO-BDDjQL.A.xjG.5bzpIB@albercik> <Pine.LNX.4.64.0808170033330.25704@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0808170033330.25704@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808171418.57558.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 17 of August 2008, Hugh Dickins wrote:
> On Sat, 16 Aug 2008, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11237
> > Subject		: corrupt PMD after resume
> > Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> > Date		: 2008-08-02 9:51 (15 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121767073424952&w=4
> > Handled-By	: Hugh Dickins <hugh@veritas.com>
> 
> Definitely should still be listed: Alan has verified it still happens
> with -rc3.  I keep on going back to look at the info he's sent, to
> try and work out what might be happening and what to try next.

Thanks for the update.

Rafael
