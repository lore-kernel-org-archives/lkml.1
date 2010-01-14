Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469Ab0ANOkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab0ANOkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 09:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336Ab0ANOkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 09:40:51 -0500
Received: from khc.piap.pl ([195.187.100.11]:54325 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab0ANOkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 09:40:51 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Seth Heasley <seth.heasley@intel.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.32.3] ahci: AHCI and RAID mode SATA patch for Intel  Cougar Point DeviceIDs
References: <201001121700.18234.seth.heasley@intel.com>
	<4B4D4EAA.2010109@gmail.com> <4B4DAA68.60608@pobox.com>
	<m3my0i6nou.fsf@intrepid.localdomain> <4B4DFE1A.4000606@pobox.com>
	<m3iqb57ts7.fsf@intrepid.localdomain>
	<51f3faa71001131557n52e34260k13bf1fe3057bb0e@mail.gmail.com>
Date: Thu, 14 Jan 2010 15:40:47 +0100
In-Reply-To: <51f3faa71001131557n52e34260k13bf1fe3057bb0e@mail.gmail.com>
	(Robert Hancock's message of "Wed, 13 Jan 2010 17:57:22 -0600")
Message-ID: <m3iqb4iwb4.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock <hancockrwd@gmail.com> writes:

> The behavior here is strange, the controller reports a connection
> status change interrupt with CommWake which should indicate that some
> device completed the handshake with the controller, but then the SATA
> link shows down. I assume there's nothing plugged into the two JMicron
> SATA ports?

Precisely nothing. Only the PATA is connected.
-- 
Krzysztof Halasa
