Return-Path: <linux-kernel-owner+w=401wt.eu-S1161601AbXDLMZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161601AbXDLMZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 08:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161598AbXDLMZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 08:25:23 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:58176 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161601AbXDLMZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 08:25:22 -0400
X-Sasl-enc: 1C18zRz6gE+oDLu6+uLnvbSWPTzQO5LBLLXpPuocPuDz 1176380721
Date: Thu, 12 Apr 2007 09:25:02 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Greg KH <greg@kroah.com>
Cc: Anton Vorontsov <cbou@mail.ru>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, dwmw2@infradead.org
Subject: Re: [PATCH 3/7] [RFC] Battery monitoring class
Message-ID: <20070412122502.GA26156@khazad-dum.debian.net>
References: <20070411232503.GC20095@zarina> <20070412034323.GA7017@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412034323.GA7017@kroah.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007, Greg KH wrote:
> Ok, yes, you want a conditional type of attribute group, like the
> new firewire code does.  I have no problem adding that if you like.

Please do.  I want that for ibm-acpi/thinkpad-acpi as well.  Right now I
need to use multiple attribute groups because of that.  Some hwmon drivers
are in the same boat, too.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
