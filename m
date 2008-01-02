Return-Path: <linux-kernel-owner+w=401wt.eu-S1755614AbYABR0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbYABR0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 12:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbYABR0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 12:26:10 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:54064 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbYABR0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 12:26:09 -0500
Date: Wed, 2 Jan 2008 18:26:07 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Eric Paris <eparis@redhat.com>
cc: Greg KH <greg@kroah.com>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org, jmorris@namei.org, alan@redhat.com,
       chrisw@redhat.com, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, solar@openwall.com,
       wtarreau@hera.kernel.org
Subject: Re: [PATCH] Allow Kconfig to set default mmap_min_addr protection
In-Reply-To: <1199293771.3716.21.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0801021825550.14900@fbirervta.pbzchgretzou.qr>
References: <1198101545.6197.52.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0712200027230.5524@fbirervta.pbzchgretzou.qr> 
 <1198269079.3732.3.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0712212209240.11671@fbirervta.pbzchgretzou.qr> 
 <20071221211602.GA14811@1wt.eu>  <Pine.LNX.4.64.0712212303410.18570@fbirervta.pbzchgretzou.qr>
  <20071221223526.GC24780@kroah.com>  <Pine.LNX.4.64.0712212358440.25803@fbirervta.pbzchgretzou.qr>
 <1199293771.3716.21.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 2 2008 12:09, Eric Paris wrote:
>
>So in the end we are all happy with the original patch I sent?
>
No objections at least :)
