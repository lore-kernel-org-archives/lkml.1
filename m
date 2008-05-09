Return-Path: <linux-kernel-owner+w=401wt.eu-S1761243AbYEILpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761243AbYEILpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 07:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbYEILp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 07:45:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:62234 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbYEILp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 07:45:27 -0400
Message-ID: <53679b7f4a82cba4410c549b07d8e48f.squirrel@housecafe.dyndns.org>
In-Reply-To: <48231959.4050406@goop.org>
References: <fa.QTbvQYXhEm5VNP5dvkl5JG7NHYQ@ifi.uio.no>
    <481DF3D8.3010108@shaw.ca>
    <a6dd201e0149f8dbdf10a7a194673833@kernel.crashing.org>
    <48217674.8080903@goop.org> <48231959.4050406@goop.org>
Date: Fri, 9 May 2008 13:45:02 +0200 (CEST)
Subject: Re: [PATCH] common implementation of iterative div/mod
From: "Christian Kujau" <lists@nerdbynature.de>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Segher Boessenkool" <segher@kernel.crashing.org>,
       "Robert Hancock" <hancockr@shaw.ca>,
       "Christian Kujau" <lists@nerdbynature.de>,
       "LKML" <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "john stultz" <johnstul@us.ibm.com>
User-Agent: SquirrelMail/1.5.2 [SVN]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Provags-ID: V01U2FsdGVkX18fie8QqogEJwDgg/Mc5cmb5fVoLrhMFDJrjuZ
 SYtTZJydlv5zstsDVCwRtgHnnV+TId+cG1zEo0jt7VWCwsSXod
 O8pJ/YEukta98B019YS3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,

On Thu, May 8, 2008 17:16, Jeremy Fitzhardinge wrote:
> This patch creates a single implementation of this loop, and uses it
> to replace the open-coded versions I know about.

Thanks for the patch. Applying to 2.6.26-rc1 allowed me to compile with
gcc-4.3. Feel free to add a Tested-by :-)

Thanks,
Christian.
-- 
BOFH excuse #442:

Trojan horse ran out of hay

