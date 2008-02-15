Return-Path: <linux-kernel-owner+w=401wt.eu-S1757652AbYBOPZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652AbYBOPZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 10:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756478AbYBOPY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 10:24:59 -0500
Received: from el-out-1112.google.com ([209.85.162.183]:19736 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757059AbYBOPY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 10:24:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TRtkL5c2sAOyvZylDGhNyxwpzscHCFltFebcXpWIsyL02yYjsKvi+HUBNc8StCgMXR5uPdu11HfLBdbh/onQmYN8fc1lxoTrRV2impeAHRXcDbcNGrI6D2HJM9SiZpjmv96rQ41QV/tlEnlfHdu9sjNHki0p4TTd+k2ZQ0fiMJA=
Message-ID: <e2e108260802150724k4e5e6089mcb603b524157a9bc@mail.gmail.com>
Date: Fri, 15 Feb 2008 16:24:56 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Denys Fedoryshchenko" <denys@visp.net.lb>
Subject: Re: BUG/ spinlock lockup, 2.6.24
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080215150044.M24489@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080215150044.M24489@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/2/15 Denys Fedoryshchenko <denys@visp.net.lb>:
>  I have random crashes, at least once per week. It is very difficult to catch
>  error message, and only recently i setup netconsole. Now i got crash, but
>  there is no traceback and only single line came over netconsole, mentioned
>  before.

Did you already run memtest ? You can run memtest by booting from the
Knoppix CD-ROM or DVD. Most Linux distributions also have included
memtest on their bootable distribution CD's/DVD's.

Bart Van Assche.
