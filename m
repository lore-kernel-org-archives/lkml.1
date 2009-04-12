Return-Path: <linux-kernel-owner+w=401wt.eu-S1759689AbZDLAMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759689AbZDLAMb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 20:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbZDLAMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 20:12:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:2381 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbZDLAMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 20:12:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=J9GEUKWO+MenrbCpGXfQVHa0ScgVxRECtDS8SWjthr7ZVP+eTQ51sbvVRd0yvmhWY+
         hDkKpiVETI87RkAP40A9pXb5S116t5AoSEXwAsjvuECTjdV4guXRhF/d9gtaQiHWRIEY
         jXc4Ca7/1VIf+67ZvAmqikmzjxD+x8/JQ8D7E=
Date: Sat, 11 Apr 2009 17:12:12 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: Don't use IRQF_SAMPLE_RANDOM in wm97xx driver
Message-ID: <20090412001212.GA30710@dtor-d630.eng.vmware.com>
References: <1239357192-27726-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1239357192-27726-2-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239357192-27726-2-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Apr 10, 2009 at 10:53:12AM +0100, Mark Brown wrote:
> The input core will add entropy to the pool without this flag being
> used.
> 

Apllied this and the atmel driver one, thank you.

-- 
Dmitry
