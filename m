Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab0CBNyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 08:54:17 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41036 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab0CBNyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 08:54:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=sGlrxz39XJ0nvMH5WbPDJOgxOcfqKnvWCHHfWxlAyDjO4m4Gn4wGMufvlbnp8+FCTy
         Fb9HeKkkh5Fiol7XA2JwyCQ84K1a/nYXas+NCtOenL/zqPbduLhMD/RWIGafnKAxVHYP
         lKS8Z5fWXX5QPPGY6hgl+KXq2+TZoQQhccd+A=
MIME-Version: 1.0
Date: Tue, 2 Mar 2010 19:24:15 +0530
Message-ID: <9bde694e1003020554p7c8ff3c2o4ae7cb5d501d1ab9@mail.gmail.com>
Subject: kmemleak for MIPS
From: naveen yadav <yad.naveen@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I want to check kmemleak for both ARM/MIPS. i am able to find kernel
patch for ARM at
http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-04/msg11830.html.
But I could not able to trace patch for MIPS.

Kind Regards
Naveen
