Return-Path: <linux-kernel-owner+w=401wt.eu-S1031530AbXHMNnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031530AbXHMNnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762907AbXHMKIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 06:08:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:41494 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761548AbXHMKHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 06:07:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=S0JlnvT1fpQd0+7FZ4Aoc1xuvY12G0GfJPXB5DQxPsqRIke/JZwmyXRnT4AkhfgM2648QObe9PzL9gdIC14oQ1KJ5yL7bOfsVieUG5Crr6UCY8fv72N1Juuh4Wx1pNe9oilr1zGJfikW7pk3Mw7D4RTTebDlMqKz+BnPf++E5xU=
Message-ID: <46C02D52.40002@gmail.com>
Date: Mon, 13 Aug 2007 14:07:14 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Norbert Preining <preining@logic.at>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: regression from 2.6.23-rc2 to -rc3 BAT missing
References: <20070813094354.GA4881@gamma.logic.tuwien.ac.at>
In-Reply-To: <20070813094354.GA4881@gamma.logic.tuwien.ac.at>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Norbert,

Do you know if you have SBS or CM battery? 
What driver do you use: sbs.ko or battery.ko?

Regards,
Alex.



Norbert Preining wrote:
> Hi all!
> 
> Starting with 2.6.23-rc3 the battery from my laptop (Acer TM3012) is
> missing for linux (but not physically):
> 
> ACPI: AC Adapter [ACAD] (on-line)
> ACPI: Battery Slot [BAT1] (battery absent)
> 
> But it is definitely there and running, even when I unplug the AC power.
> 
> Any patch I can use to change this?
> 
> Best wishes
> 
> Norbert
> 
> -------------------------------------------------------------------------------
> Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
> Debian Developer <preining@debian.org>                         Debian TeX Group
> gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> -------------------------------------------------------------------------------
> GLOSSOP (n.)
> A rouge blob of food. Glossops, which are generally streaming hot and
> highly adhesive invariably fall off your spoon and on to the surface
> of your host's highly polished antique-rosewood dining table. If this
> has not, or may not have, been noticed by the company present, swanage
> (q.v.) may be employed.
> 			--- Douglas Adams, The Meaning of Liff
> -
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

