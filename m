Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbZBGDD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbZBGDD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 22:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbZBGDDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 22:03:50 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:46314 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745AbZBGDDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 22:03:50 -0500
X-Sasl-enc: 6fSf6JEBYjegFr6fpoM5Qeh6/eEhLLR/6eqpxfHKyKWx 1233975829
Date: Sat, 7 Feb 2009 01:03:46 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andi Kleen <andi@firstfloor.org>
Cc: Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
Subject: Re: marching through all physical memory in software
Message-ID: <20090207030346.GB5587@khazad-dum.debian.net>
References: <497DD8E5.1040305@nortel.com> <87bptgvt1t.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bptgvt1t.fsf@basil.nowhere.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Feb 2009, Andi Kleen wrote:
> "Chris Friesen" <cfriesen@nortel.com> writes:
> > Someone is asking me about the feasability of "scrubbing" system
> > memory by accessing each page and handling the ECC faults.
> 
> I would expect any ECC RAM capable memory controller designed 
> in the last 10-15 years to be able to do this on its own without
> software intervention. Is that not true? It is certainly
> on x86 (although you sometimes have to change BIOS options)

Is that true for the 82875, and other common desktop chipsets that DO
support ECC ram?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
