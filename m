Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193Ab0AKK2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab0AKK2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 05:28:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111Ab0AKK2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 05:28:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915Ab0AKK2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 05:28:00 -0500
Message-ID: <4B4AFD25.1080001@redhat.com>
Date: Mon, 11 Jan 2010 12:27:49 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <Stephen@Rothwell.id.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexander Graf <agraf@suse.de>
Subject: Re: linux-next: kvm tree build failure
References: <20100111190749.0a74d445.Stephen@Rothwell.id.au>
In-Reply-To: <20100111190749.0a74d445.Stephen@Rothwell.id.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2010 10:07 AM, Stephen Rothwell wrote:
> Hi Avi,
>
> Today's linux-next build (powerpc ppc44x_defconfig) failed like this:
>
>    

I pushed out a fix from Alex.

-- 
error compiling committee.c: too many arguments to function

