Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759140Ab0BYK2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:28:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759126Ab0BYK2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:28:38 -0500
Message-ID: <4B8650CF.6@redhat.com>
Date: Thu, 25 Feb 2010 12:28:31 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] KVM: SVM: Implement emulation of vm_cr msr
References: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com> <1267034360-5907-7-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1267034360-5907-7-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2010 07:59 PM, Joerg Roedel wrote:
> This patch implements the emulation of the vm_cr msr for
> nested svm.
>
>    

This needs to be exposed to userspace for save/restore.

-- 
error compiling committee.c: too many arguments to function

