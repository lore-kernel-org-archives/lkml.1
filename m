Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbXJXHoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbXJXHoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 03:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbXJXHoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 03:44:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:3865 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbXJXHoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 03:44:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=E4Di0Tc7RokRhNorF2VTdBVdF8MF+5ja/C3atkvq6v7Q+oUVybr/HlGWx5ogdOKZlDlHKcPMgRbN6bOpsh4lZpcOU8hUKdEg79ccv92KOtZG82fQN1e8T5w9cAiR+AknxjCYrH7afrc5bFiIVehUVzE/vhnTQo7CvUNzQvmNQ7s=
Message-ID: <471EF7C6.8060904@gmail.com>
Date: Wed, 24 Oct 2007 09:44:06 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: [PATCH 4/12] riscom8: fix SMP brokenness
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org> <20071023223638.DD9FE1F81A8@havoc.gtf.org> <471EEA7B.8070008@gmail.com> <471EEBCB.30804@garzik.org>
In-Reply-To: <471EEBCB.30804@garzik.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2007 08:52 AM, Jeff Garzik wrote:
> Jiri Slaby wrote:
>> Revieweved-by: Jiri Slaby <jirislaby@gmail.com>
> 
> I noticed you reviewed my other riscom8 patch... you don't have hardware
> perchance, do you?  :)

No, otherwise I told you so :).
