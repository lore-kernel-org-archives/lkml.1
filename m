Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091Ab0ASX6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab0ASX6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 18:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756004Ab0ASX63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 18:58:29 -0500
Received: from mail-iw0-f197.google.com ([209.85.223.197]:33982 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996Ab0ASX62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 18:58:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=oAbT0ACX14B7X2Qw3TydYrQQnMyN4UUu7Grjj6h/3WDGolCqd/vXJ61fZQ/osig5yA
         CXEokel4dMtK9ErxVOdHUtW82dO2IxDulASh33lUBVecl3EYZuk5+CgyBhYD3hGKIgSh
         UP2c4LldUvzxvGHc2X4254u5RPosASY2xvxNw=
Message-ID: <4B564721.1020504@gmail.com>
Date: Tue, 19 Jan 2010 18:58:25 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Linux Kernel Developers <linux-kernel@vger.kernel.org>
CC: Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3] tcp: input header length, prediction, and timestamp
 bugs
References: <4B49C2D0.1070704@gmail.com> <4B561371.3030605@gmail.com>
In-Reply-To: <4B561371.3030605@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missing 1 part of the patch.  My mistake cutting the patches apart
from the bigger testing patch.  I'll send a new version promptly.
