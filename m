Return-Path: <linux-kernel-owner+w=401wt.eu-S934647AbXFFPoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934647AbXFFPoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 11:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760338AbXFFPoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 11:44:46 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:36437 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758901AbXFFPop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 11:44:45 -0400
X-Sasl-enc: 98QVzC3rUx3vLoDYVI7MDDNy5fslDf3G8Gz3hnM8NxdK 1181144684
Date: Wed, 6 Jun 2007 12:44:42 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bad behaviour after hdparm -M  128
Message-ID: <20070606154442.GB13166@khazad-dum.debian.net>
References: <fa.DWgGSeKzniALToNSyX9W5NibA1w@ifi.uio.no> <4666C4B9.8060408@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4666C4B9.8060408@shaw.ca>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007, Robert Hancock wrote:
> >I used kernel 2.6.21 with the libata PIIX SATA driver and a
> >Seagate ST98823AS drive.
> 
> Yes, that's expected if the drive rejects the command.

Are *all* SATA drives rejecting the command?  Mine doesn't accept it,
either.  And it should, AFAIK, unless IBM's HDAPS-enabled firmware started
ripping out accousting management from Hitachi drives, which I don't find
very likely...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
