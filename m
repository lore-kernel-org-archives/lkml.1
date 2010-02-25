Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623Ab0BYUP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 15:15:57 -0500
Received: from claw.goop.org ([74.207.240.146]:55533 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933299Ab0BYUP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 15:15:56 -0500
Message-ID: <4B86DA7A.9090706@goop.org>
Date: Thu, 25 Feb 2010 12:15:54 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Alok N Kataria <akataria@vmware.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: VMI and kmap_atomic_pte paravirt_op
References: <1267127532.2488.7.camel@localhost.localdomain>
In-Reply-To: <1267127532.2488.7.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2010 11:52 AM, Ian Campbell wrote:
> How critical is the vmi_kmap_atomic_pte pv_mmu_op hook to VMI? Is it
> required for correct functionality or is it simply an optimisation?
>    

Or disable high ptes for VMI too.



     J
