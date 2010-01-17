Return-Path: <linux-kernel-owner+w=401wt.eu-S1751221Ab0AQMmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221Ab0AQMmx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 07:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823Ab0AQMmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 07:42:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743Ab0AQMmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 07:42:51 -0500
Message-ID: <4B5305CA.5070001@redhat.com>
Date: Sun, 17 Jan 2010 14:42:50 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Davide Libenzi <davidel@xmailserver.org>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] kvm: fix spurious interrupt with irqfd
References: <20100113171222.GA19798@redhat.com>
In-Reply-To: <20100113171222.GA19798@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2010 07:12 PM, Michael S. Tsirkin wrote:
> Deassigning irqfd and assigning back caused spurious interrupt. fix this
> by clearing the counter on deassign.  This is on top of davidel's patch
> which makes clearing eventfd counter from modules possible.
>    

Applied both, thanks.

-- 
error compiling committee.c: too many arguments to function

