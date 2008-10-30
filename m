Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbYJ3QN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbYJ3QN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757182AbYJ3QM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:12:28 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:52082 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173AbYJ3QM0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:12:26 -0400
Date: Thu, 30 Oct 2008 17:12:02 +0100
Message-Id: <488915452@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: =?iso-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: how much license information inside the kernel ?
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18NUjP49FRNmnuJK7qlQWvGoufXhopTiMKzNsJxak7aRx1xD
 v4DAOq+DxYQ7fofbXyfig7MuHsgNYM+0i5EzcCg9ODsTeb5jNQ=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 30 October 2008 11:54:57 +0100, devzero@web.de wrote:
> > 
> > i found that there is a LOT of repeating licensing information in the kernel.
> > 
> > for me, 
> > 
> > find ./linux-2.6.27 -type f -exec cat {} \; |egrep "free software|GNU General Public License|Free Software Foundation|version 2 of the License|distributed in the hope|WITHOUT ANY WARRANTY|FITNESS FOR A PARTICULAR"
> > 
> > gives a file sized ~3.5M
> > 
> > That`s more than 1% of the kernel source.
> 
> Scary, isn't it?

i´m not really scared, but it`s a really impressing amount. :)

> One of the problems is that corporate lawyers require the full GPL
> preample in any source file.  As a result, a lot of developers inside
> companies cannot publish code without it.  Whether that makes any sense
> is anyone's guess.  But it doesn't cause much harm either, so better
> leave the bloat where it is.

i feared something like that.

so, if it`s not just a common bad habit to add those lines again and again 
but  something being forced by lawyers - it would indeed not being worth
the effort to adress this, as you would need to review and discuss every 
single file containing those lines....

thanks for feedback

roland

__________________________________________________________________
"Run, Fatboy, Run" sowie "Rails & Ties" kostenlos anschauen!
Blockbuster-Gutscheine sichern unter http://www.blockbuster.web.de

