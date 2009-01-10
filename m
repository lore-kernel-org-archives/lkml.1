Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbZAJVav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbZAJVav (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 16:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbZAJVag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 16:30:36 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:55880 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056AbZAJVae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 16:30:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=VBysssLgE93dprpea5nIjjONF7W5owldEFHzK6LxEavKxgBtdbywDKpiDeey78Rabs
         i4lIhg1ERo/viOtnpSZ0tjihMPH//FyDo0r5NS9gXxT6WCXPXI1tRKIUmENfO255qtkZ
         CGLWi0M4kOvhmmYTirXGqWqMjpJDZYzjKQ99g=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Rikard Ljungstrand <lrikard@student.chalmers.se>
Subject: Re: [PATCH] Input: Add keyboard quirk for HP Pavilion ZV6100 laptop
Date: Sat, 10 Jan 2009 13:29:51 -0800
User-Agent: KMail/1.10.3 (Linux/2.6.27.9-159.fc10.x86_64; KDE/4.1.3; x86_64; ; )
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       apw@canonical.com
References: <4968A391.2000400@student.chalmers.se>
In-Reply-To: <4968A391.2000400@student.chalmers.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901101329.51731.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 January 2009 05:33:05 Rikard Ljungstrand wrote:
> Hi,
>
> Sending an updated version of a trivial patch from last November which got
> no feedback on the list. Applies cleanly against the latest input.git tree
> (and probably other recent trees).
>

It got applied silently ;) Its in mainline now, as part of 2.6.29.

-- 
Dmitry
