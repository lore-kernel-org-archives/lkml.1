Return-Path: <linux-kernel-owner+w=401wt.eu-S934980AbXG0JMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934980AbXG0JMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761493AbXG0JMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:12:36 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:63389 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759211AbXG0JMf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:12:35 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/5 v3] Add the explanation and a sample of RapidIO OF node to the document of booting-without-of.txt file.
Date: Fri, 27 Jul 2007 17:12:31 +0800
Message-ID: <46B96294322F7D458F9648B60E15112C74D158@zch01exm26.fsl.freescale.net>
In-Reply-To: <98CA70A1-9888-4508-A0E9-0EB28C14945F@kernel.crashing.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/5 v3] Add the explanation and a sample of RapidIO OF node to the document of booting-without-of.txt file.
Thread-Index: AcfQK0Rv+GwT/7jSRWiV3WBefVTQeQAAkG+w
References: <11854393721520-git-send-email-wei.zhang@freescale.com> <11854393733580-git-send-email-wei.zhang@freescale.com> <98CA70A1-9888-4508-A0E9-0EB28C14945F@kernel.crashing.org>
From: "Zhang Wei-r63237" <Wei.Zhang@freescale.com>
To: "Kumar Gala" <galak@kernel.crashing.org>
Cc: <mporter@kernel.crashing.org>, <paulus@samba.org>,
       <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kumar, 
> +   RapidIO is a definition of a system interconnect. This node add
> > +   the support for RapidIO processor in kernel. The node name is
> > +   suggested to be 'rapidio'.
> > +
> > +   Required properties:
> > +
> > +    - compatible : Using "fsl,rapidio-delta" for Freescale PowerPC
> > +      RapidIO controller.
> > +    - #address-cells : Address representation for 
> "rapidio" devices.
> > +      This field represents the number of cells needed to represent
> > +      the RapidIO address of the registers.
> 
> Can you explain this a little further.  I'm a bit confused by  
> 'RapidIO address of the registers'.
> 
I want to present "This field represents the number of cells [needed to
represent the RapidIO address] of the registers."
Maybe I should remove 'of the registers' to be more clear.

Thanks!
-zw
