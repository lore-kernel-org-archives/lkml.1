Return-Path: <linux-kernel-owner+w=401wt.eu-S1756927AbZJCTas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbZJCTas (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 15:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756865AbZJCTar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 15:30:47 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:63519 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756860AbZJCTaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 15:30:46 -0400
From: "Trevor Hemsley" <trevor.hemsley@ntlworld.com>
To: "Frans Pop" <elendil@planet.nl>, "Ingo Molnar" <mingo@elte.hu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 03 Oct 2009 20:28:01 +0100 (BST)
Reply-To: "Trevor Hemsley" <trevor.hemsley@ntlworld.com>
X-Mailer: PMMail 2.20.2382 for OS/2 Warp 4.5
In-Reply-To: <20091002175745.GB14860@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Subject: Re: Temperature above threshold loop with 2.6.31.1
Message-Id: <20091003193007.RFEY13254.aamtaout01-winn.ispmail.ntl.com@trevor2.dsl.pipex.com>
X-Cloudmark-Analysis: v=1.0 c=1 a=Mn_KBvnTDGAA:10 a=9YlaCzn6_68A:10 a=zEnuPh1yBppguHVDmKAA:9 a=4ePxfAotSSOZeg7uTdmoEnI8_8QA:4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Oct 2009 19:57:45 +0200, Ingo Molnar wrote:

>Yes. The way to test this is to do this on top of a .31.1 tree:
>
> git cherry-pick 3967684006f30c253bc6d4a6604d1bad4a7fc672
> git cherry-pick b417c9fd8690637f0c91479435ab3e2bf450c038

The fix was tested and the fix was good.

It's still hot and throttling but the messages are only issued every ~5
mins now.

Thanks.
-- 
Trevor Hemsley, Brighton, UK
Trevor dot Hemsley at ntlworld dot com

