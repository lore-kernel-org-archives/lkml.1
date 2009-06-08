Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbZFHGOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbZFHGOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 02:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZFHGOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 02:14:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51318 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbZFHGOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 02:14:11 -0400
Message-ID: <4A2CAC32.5030904@redhat.com>
Date: Mon, 08 Jun 2009 09:14:10 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Kallol Biswas <nucleodyne@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: looking for ideas on VM related research projects
References: <438397970906072249pe76fafdj49626f20eea31eab@mail.gmail.com>
In-Reply-To: <438397970906072249pe76fafdj49626f20eea31eab@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kallol Biswas wrote:
> Hi,
>    I have a strong team of good, energetic and young kernel engineers
> and research scholar and I am looking for ideas on linux virtual
> memory related research projects for them.
>
> Any input or pointers on future virtual memory projects will be appreciated.
>
>   

- automatically using and breaking up large pages
- task/vma affinity
- automatically migrating memory when thread/vma affinity cannot be 
satisfied

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

