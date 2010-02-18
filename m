Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab0BROdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 09:33:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756060Ab0BROdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 09:33:36 -0500
Message-ID: <4B7D4FBA.2030204@redhat.com>
Date: Thu, 18 Feb 2010 16:33:30 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH 0/10] Nested SVM fixes (and Win7-64bit bringup)
References: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2010 01:38 PM, Joerg Roedel wrote:
> Hi,
>
> here is a couple of fixes for the nested SVM implementation. I collected these
> fixes mostly when trying to get Windows 7 64bit running as an L2 guest. Most
> important fixes in this set make lazy fpu switching working with nested SVM and
> the nested tpr handling fixes. Without the later fix the l1 guest freezes when
> trying to run win7 as l2 guest. Please review and comment on these patches :-)
>    

Overall looks good.  Would appreciate Alex looking over these as well.

-- 
error compiling committee.c: too many arguments to function

