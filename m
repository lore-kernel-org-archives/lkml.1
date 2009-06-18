Return-Path: <linux-kernel-owner+w=401wt.eu-S1758154AbZFRWM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbZFRWM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 18:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbZFRWMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 18:12:15 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54305 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240AbZFRWMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 18:12:14 -0400
X-Sasl-enc: aeQd8KRn/xrLaE3fQqmEaRJlb9qlna8KP0K9nECepsmj 1245363136
Date: Thu, 18 Jun 2009 19:12:13 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Platte <jplatte@naasa.net>
Subject: Re: [2.6.30] Kernel bug with dock driver
Message-ID: <20090618221213.GB2979@khazad-dum.debian.net>
References: <200906142100.48621.jplatte@naasa.net> <1245222796.9076.93.camel@rzhang-dt> <200906182326.57887.jplatte@naasa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906182326.57887.jplatte@naasa.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009, Joerg Platte wrote:
> Am Wednesday, 17. June 2009 schrieb Zhang Rui:
> 
> > jplatte,
> > it would be great if you can verify if this is a regression or not.

Something is causing ACPI devices to have NULL for dev_name().  This
broke thinkpad-acpi.  Any ideas?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
