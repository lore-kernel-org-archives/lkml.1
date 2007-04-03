Return-Path: <linux-kernel-owner+w=401wt.eu-S1945963AbXDCVZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945963AbXDCVZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 17:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945964AbXDCVZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 17:25:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:58699 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945963AbXDCVZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 17:25:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CLRS4PCkfX9iBEgMylmOAOEVzesr6eme+NJ6VWhZr/FT6I2dFcEtmNSMio5RxWtc0WoQKg3Syk8yAWyHG7KSxj/fUJ/NofExnpSZ+tKjQUhBdyUGdpGeVcoWGX0NQTXyY7gu/5Z/95MKVqicR74HvNEEQe7kizbuV2ls97DIiAI=
Message-ID: <3df49b7b0704031425y57418c21ge4cba7116f5b4745@mail.gmail.com>
Date: Tue, 3 Apr 2007 23:25:06 +0200
From: RusH <citizenr@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: 2.6.21-rc5: Thinkpad X60 gets critical thermal shutdowns
Cc: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Alexey Starikovskiy" <aystarik@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <46129E7D.60103@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <460E0158.7090705@goop.org>
	 <8f8ff01d0703310033y74421cfcl747ece1be003471@mail.gmail.com>
	 <460F511E.2090102@goop.org> <46103DF2.30001@goop.org>
	 <20070402023846.GC28561@khazad-dum.debian.net>
	 <46108C52.7030301@goop.org>
	 <20070403123431.GA24717@khazad-dum.debian.net>
	 <46129E7D.60103@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/3/07, Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Attached.  Is there some tool for decoding the DSDT?

iasl
http://www.intel.com/technology/iapc/acpi/downloads.htm
http://www.intel.com/technology/iapc/acpi/license2.htm

--
Who logs in to gdm? Not I, said the duck.
