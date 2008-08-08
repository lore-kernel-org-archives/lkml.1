Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbYHHAxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbYHHAxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbYHHAxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:53:23 -0400
Received: from mail.lang.hm ([64.81.33.126]:57620 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbYHHAxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:53:23 -0400
Date: Thu, 7 Aug 2008 17:54:11 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: why are namespaces required?
Message-ID: <alpine.DEB.1.10.0808071752210.892@asgard.lang.hm>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am taking the time to create a minimal config for some new hardware with 
2.6.25.15 and noticed that CONFIG_NAMESPACES is forced to Yes unless 
embeded is selected (at which time it becomes configurable)

why are namespaces required?

David Lang
