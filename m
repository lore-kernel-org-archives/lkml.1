Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbZCSXL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbZCSXL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 19:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbZCSXLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 19:11:47 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:31827 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbZCSXLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 19:11:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=XMnblHiir8YiFK6+dp77hmRszjC8q8YyMxtsdjYfCO1VS/KP53pTae2scRqzm/m4LC
         nv0pVGEWMwKnzi98rOuTnPrAHDrM8zOaL3RCaMpCeJbj0qm5QtkMkZRIB5qF2tMwIj79
         1nO/NGIMSgM7QbByBMQ2tLEjK1ykvOZYXBksA=
Message-ID: <49C2D126.3050807@gmail.com>
Date: Fri, 20 Mar 2009 08:11:34 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] ahci: Blacklist HP Compaq 6720s that spins off disks
 during ACPI power off
References: <200903200006.46859.rjw@sisk.pl>
In-Reply-To: <200903200006.46859.rjw@sisk.pl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> From: Maciej Rutecki <maciej.rutecki@gmail.com>
> 
> Blacklist HP Compaq 6720s so that it doesn't play a "spin down,
> spin up, spin down" ping-pong with the hard disk during system
> power off.
> 
> Signed-off-by: Maciej Rutecki <maciej.rutecki@gmail.com>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
