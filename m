Return-Path: <linux-kernel-owner+w=401wt.eu-S1760057AbZF2OW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057AbZF2OW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 10:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbZF2OWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 10:22:48 -0400
Received: from ey-out-1920.google.com ([74.125.78.150]:5425 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbZF2OWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 10:22:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EihyS/7YuJE2irqjG5HHLaUq3XAxNDYvIK0Fox0yl5aifYc6p+4hFRDINiP91K19vd
         8ID1VRGjp4dfkpfGZkGCaQ/JEtDahjT2Y8ML0B9AGhWlYnFgi0x68uae+pTXbpZtU1Qs
         i7/JXpcLSfaPOArhkTseNAQBLAOaJYOuG6elE=
Message-ID: <4A48CE37.3000104@tuffmail.co.uk>
Date: Mon, 29 Jun 2009 15:22:47 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Corentin Chary <corentincj@iksaif.net>,
       linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] eeepc-laptop: fix hot-unplug on resume
References: <4A48A196.3060409@tuffmail.co.uk> <200906291616.57440.rjw@sisk.pl>
In-Reply-To: <200906291616.57440.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Monday 29 June 2009, Alan Jenkins wrote:
>   
>> The patch below fixes a regression introduced by the rfkill rewrite. 
>> Please consider it for inclusion in 2.6.31 via the ACPI tree.
>>     
>
> Is there a Bugzilla # for this regression?
>
> Rafael
>   

No.

I found it in testing, a few days after I'd submitted the change myself :-/.

Thanks
Alan
