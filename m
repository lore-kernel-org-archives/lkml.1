Return-Path: <linux-kernel-owner+w=401wt.eu-S1752163AbZERRhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbZERRhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 13:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbZERRhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 13:37:06 -0400
Received: from mail.lang.hm ([64.81.33.126]:51866 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbZERRhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 13:37:05 -0400
Date: Mon, 18 May 2009 10:37:06 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: -stable regression 2.6.29.3 vs 2.6.29.1
Message-ID: <alpine.DEB.1.10.0905181035530.15782@asgard>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't have time to bisect this right now, but forcedeth broke somewhere 
between these two (NICs not detected). in 2.6.30-rc6 it is functioning 
properly.

David Lang
