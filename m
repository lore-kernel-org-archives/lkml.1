Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbYJJLJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbYJJLJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 07:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbYJJLJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 07:09:17 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:35925 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbYJJLJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 07:09:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eyYSPY5j+7FC4WQZk20+cRyNcYxyq/Y3LDZpdU+gGzN7/HkXv/QVBDignFlpkTjZ70
         E6rd17Qnc2/zH4eljNEPXEiba68waePg0izhn+QEEwy7sL9IKeZec+6aHpAzOBDDBcFC
         B6BDA1629hldOEw3Y+6ug5Ye/ljfTVwr+TxbU=
Message-ID: <c62985530810100409n59521861qe89e4960703684f@mail.gmail.com>
Date: Fri, 10 Oct 2008 13:09:15 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/6] Tracing/fastboot: Enable boot tracing only during initcalls
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081010110445.GA12519@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081010103615.EFB18D1BB8F@perso1.free.fr>
	 <20081010105819.GA4699@elte.hu>
	 <c62985530810100402of7e1b48n4aac01d69433c1f5@mail.gmail.com>
	 <20081010110445.GA12519@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/10 Ingo Molnar <mingo@elte.hu>:
> dont worry, i fixed them already when i applied your patch (and that's
> all in latest tip/master).
>
> See the commit below - i sanitize most commit entries to make subject
> lines more consistent (note the capitalization difference between your
> submission and the end result), to improve paragraphing and general
> structure.
>
>        Ingo

Oh ok, that's great. Thank you.
And since my english is not really perfect...and since this makes some
times to be patched... :-)
