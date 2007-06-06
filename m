Return-Path: <linux-kernel-owner+w=401wt.eu-S935612AbXFFVws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935612AbXFFVws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 17:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757135AbXFFVwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 17:52:40 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45140 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755804AbXFFVwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 17:52:39 -0400
X-Sasl-enc: rCzuc23BwuTAQYyOmIK0rnwMmcCsaCs5eU2xKCnZi+q9 1181166758
Date: Wed, 6 Jun 2007 18:52:32 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: Bad behaviour after hdparm -M  128
Message-ID: <20070606215232.GC31549@khazad-dum.debian.net>
References: <fa.DWgGSeKzniALToNSyX9W5NibA1w@ifi.uio.no> <4666C4B9.8060408@shaw.ca> <20070606154442.GB13166@khazad-dum.debian.net> <20070606162425.GA3943@atjola.homenet> <20070606164854.GA18984@khazad-dum.debian.net> <20070606175112.GA4659@atjola.homenet> <20070606210337.GA31549@khazad-dum.debian.net> <20070606213617.GA6580@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070606213617.GA6580@atjola.homenet>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007, Björn Steinbrink wrote:
> HDAPS support is available, revision is MB2IA60A.

That would usually rule out the possibility of it being the firmware, but we
have different disks, so different firmware.

It looks like I will have to try 2.6.22 to know for sure.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
