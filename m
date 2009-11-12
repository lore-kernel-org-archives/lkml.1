Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbZKLR5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbZKLR5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 12:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbZKLR5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 12:57:44 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:34178 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753642AbZKLR5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 12:57:44 -0500
Message-Id: <1258048669.20754.1344916801@webmail.messagingengine.com>
X-Sasl-Enc: 63ImrenbeZJTP1d4go7N4EJnlXw0YNC04s6TkuZP+6Es 1258048669
From: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Robert Hancock" <hancockrwd@gmail.com>,
       "Anton D. Kachalov" <mouse@mayc.ru>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
In-Reply-To: <20091112174916.59fe7805@lxorguk.ukuu.org.uk>
References: <4AFACC03.7080209@mayc.ru><4AFB2822.30906@gmail.com><20091112021209.GA21625@khazad-dum.debian.net><878web7kwf.fsf@basil.nowhere.org><1258047454.16197.1344913359@webmail.messagingengine.com>
 <20091112174916.59fe7805@lxorguk.ukuu.org.uk>
Subject: Re: Reading /dev/mem by dd
Date: Thu, 12 Nov 2009 15:57:49 -0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009 17:49 +0000, "Alan Cox" <alan@lxorguk.ukuu.org.uk> wrote:
> > In this case, the problem seems to be access over /dev/mem to stuff the
> > kernel is already taking care of.  Certainly "as safe as possible" does
> 
> Which is often what is desired - eg debugging driver stuff.
> 
> > not have to mean making /dev/mem useless for whatever good uses it has.
> 
> It does. Plain and simple.

Is that the only valid use of /dev/mem, or even its main use?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

