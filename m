Return-Path: <linux-kernel-owner+w=401wt.eu-S1759297AbYA1DU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbYA1DU6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 22:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754360AbYA1DUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 22:20:49 -0500
Received: from gw.goop.org ([64.81.55.164]:43586 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516AbYA1DUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 22:20:46 -0500
Message-ID: <479D4A0C.5080208@goop.org>
Date: Sun, 27 Jan 2008 19:20:44 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Joerg Roedel <joerg.roedel@amd.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH][RFC] SVM: Add Support for Nested Paging in
 AMD Fam16 CPUs
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com> <479C4763.1080104@qumranet.com>
In-Reply-To: <479C4763.1080104@qumranet.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>  I find it non-descriptive, and it reminds me of another hypervisor.  
> I suggest 'tlp' for two-level paging.

That has its own ambiguity; without other context it reads like 
"two-level pagetable".  Anyway, using the same term for the same thing 
is not a bad idea.

    J
