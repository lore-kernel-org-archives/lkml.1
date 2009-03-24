Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbZCXXXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbZCXXXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 19:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbZCXXXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 19:23:36 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41851 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752179AbZCXXXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 19:23:35 -0400
X-Sasl-enc: eIrVYGsU0tSVXviWB1O6eBtuocyt29CQPEHm0VR46gRb 1237937012
Date: Tue, 24 Mar 2009 20:23:29 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Thinkpad T61 - Fan running a lot of time
Message-ID: <20090324232328.GA23356@khazad-dum.debian.net>
References: <49C94620.8040309@diamondcut.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49C94620.8040309@diamondcut.com.br>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009, Renato S. Yamane wrote:
> The fan speed is ~2600RPM (always under 3000RPM), and I think that is  
> not enough to cooling the processor, because is necessary 3min to  
> decrease 1°C in Core1 and only 40sec to increase 1°C.
>
> I think that is necessary a higher fan speed.

Or a better thermal coupling between the fan assembly and the
processor...  this is a weak area on thinkpads.

If your box is still under warranty, I suggest you to use
thinkpad-acpi fan control to keep your fan at level 7 (fastest normal
fan level).  If that's not enough, call in for a motherboard
replacement.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
