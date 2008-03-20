Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbYCTKcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbYCTKcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 06:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbYCTKcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 06:32:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33171 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbYCTKcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 06:32:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: Re: APM lockups since 2.6.25
Date: Thu, 20 Mar 2008 11:31:25 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0803191608500.25941@artax.karlin.mff.cuni.cz>
In-Reply-To: <Pine.LNX.4.64.0803191608500.25941@artax.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803201131.25828.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 19 of March 2008, Mikulas Patocka wrote:
> Hi

Hi,
 
> I have an old notebook with APM and I am experiencing occasional APMD 
> lockups after resume, with kernels 2.6.25rc1 snd 2.6.25rc3. They didn't 
> happen with 2.6.24 or before.
> 
> The bug happens about once a week or so.
> 
> If you have any idea how to debug it, you can send me a test code.

It is possible that the bug was fixed in -rc4.  Can you please test -rc6 and
see if it's still present?

Thanks,
Rafael
