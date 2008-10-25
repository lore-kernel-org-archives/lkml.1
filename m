Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbYJYLnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbYJYLnk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 07:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbYJYLnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 07:43:31 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:47274 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346AbYJYLna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 07:43:30 -0400
X-Sasl-enc: ZrCx8OUCqc3NAmvIgZaQqZ3IT4EF8GZzSJyhsy/a3ZDF 1224935008
Date: Sat, 25 Oct 2008 09:43:24 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, lenb@kernel.org, fabio.comolli@gmail.com
Subject: Re: [Re: Linux 2.6.28-rc1] ACPI Warning (nspredef-0852)[...]
Message-ID: <20081025114324.GA30862@khazad-dum.debian.net>
References: <8db1092f0810250021p70be6b62wdbb9a4c1c20c7a27@mail.gmail.com> <200810251259.39233.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810251259.39233.rjw@sisk.pl>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2008, Rafael J. Wysocki wrote:
> On Saturday, 25 of October 2008, Maciej Rutecki wrote:
> > During suspend to ram I have this message:
> > 
> > ACPI Warning (nspredef-0852): \_WAK: Return type mismatch - found
> > Integer, expected Package [20080926]
> > 
> > s2ram seems works OK
> > 
> > dmesg, acpidump:
> > http://unixy.pl/maciek/download/kernel/2.6.28-rc1_wak/
> 
> IMO it's yet another incarnation of
> http://bugzilla.kernel.org/show_bug.cgi?id=11822

If this is an outright violation of the ACPI spec, let me know (and if
possible, please tell me the spec page).  This is the kind of thing I expect
it would be a no-brainer to get Lenovo to fix with a BIOS update.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
