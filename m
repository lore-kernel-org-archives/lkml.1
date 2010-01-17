Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646Ab0AQM0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab0AQM0d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 07:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908Ab0AQM0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 07:26:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab0AQM0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 07:26:31 -0500
Message-ID: <4B5301EB.8040505@redhat.com>
Date: Sun, 17 Jan 2010 14:26:19 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Xiantao Zhang <xiantao.zhang@intel.com>, kvm-ia64@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: remove redundant NULL tests
References: <4B4F4EF6.2050202@gmail.com>
In-Reply-To: <4B4F4EF6.2050202@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2010 07:05 PM, Roel Kluin wrote:
> kvm_get_exit_data() cannot return a NULL pointer.
>    

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

