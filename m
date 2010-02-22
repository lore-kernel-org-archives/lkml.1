Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab0BVLFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 06:05:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab0BVLFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 06:05:09 -0500
Message-ID: <4B8264DD.3060903@redhat.com>
Date: Mon, 22 Feb 2010 13:05:01 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 02/11] KVM: SVM: Fix wrong interrupt injection in enable_irq_windows
References: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com> <1266592990-8911-3-git-send-email-joerg.roedel@amd.com> <20100222102909.GB4210@amd.com>
In-Reply-To: <20100222102909.GB4210@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2010 12:29 PM, Joerg Roedel wrote:
> Hi Avi,
>
> forgot this one? I did not find it in your tree.
>    

Whoops, dropped it accidentally.  Thanks for checking.  Applied now.

-- 
error compiling committee.c: too many arguments to function

