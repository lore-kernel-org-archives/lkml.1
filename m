Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbXLLXld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbXLLXld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 18:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbXLLXlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 18:41:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36392 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbXLLXlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 18:41:24 -0500
Message-ID: <47607124.2020701@zytor.com>
Date: Wed, 12 Dec 2007 15:39:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, zach@vmware.com,
       roland@redhat.com
Subject: Re: [PATCH 0/19] desc_struct integration
References: <1196957800568-git-send-email-gcosta@redhat.com> <11974640441088-git-send-email-gcosta@redhat.com>
In-Reply-To: <11974640441088-git-send-email-gcosta@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> Since the last version of it received no comments on the interfaces, here
> it goes a version, that I feel ready for inclusion.
> 
> The comments regarding style, specially the elimination of the #defines in
> the desc_struct definition were merged. I also implemented the vmi
> functions,
> missing last time.
> 
> Ingo, in the absense of further complaints, could you please push to the
> x86 tree?
> 

Looks fine to me...

	-hpa
