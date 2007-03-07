Return-Path: <linux-kernel-owner+w=401wt.eu-S1161219AbXCGCRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161219AbXCGCRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 21:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161222AbXCGCRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 21:17:12 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:41558 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161219AbXCGCRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 21:17:11 -0500
X-Sasl-enc: +0c2m3BrVcpxTW+PRQTfFVVQvDcEGIP1xMpiPhxDZz2Q 1173233830
Date: Tue, 6 Mar 2007 23:16:49 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: eliminate useless bay events
Message-ID: <20070307021649.GA1448@khazad-dum.debian.net>
References: <20070306154046.942b0706.kristen.c.accardi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306154046.942b0706.kristen.c.accardi@intel.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Mar 2007, Kristen Carlson Accardi wrote:
> Eliminate bay events on resume if nothing has changed.

Are these *really* useless?  What if the *contents* of the bay changed?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
