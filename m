Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbXJYSdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbXJYSdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 14:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbXJYSdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 14:33:39 -0400
Received: from el-out-1112.google.com ([209.85.162.182]:12328 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbXJYSdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 14:33:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=spSaUEsgK7Eqf2rG64QryRsk4sRF3NHka2k0Ixnbyh0gngAV+iA4tIT57Q8LepQSJJh1/TRPzWkvctkoqHJv1O0gf8eT9e0cUB53yfthbZuZCV0BUNwRqSuwx+1qG9FZ/QwvHTewqhWcOYmXcf/t8nJTAznpGQyIiLfXjuPSqDY=
Message-ID: <fc94aae90710251133j4bada173h6298242ece586b61@mail.gmail.com>
Date: Thu, 25 Oct 2007 19:33:35 +0100
From: "Michael Lothian" <mike@fireburn.co.uk>
To: linux-kernel@vger.kernel.org
Subject: Possibility of adding -march=native to x86
In-Reply-To: <0EC33A59AA72084CA28B83816B40929F02682BB3@REEDXCLSXM01V03.rbsres01.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <0EC33A59AA72084CA28B83816B40929F02682BB3@REEDXCLSXM01V03.rbsres01.net>
X-Google-Sender-Auth: c71142b8180e2085
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I was wondering if it was possible to add -march=native support to the
processor options of the new x86 architecture if gcc 4.2 or greater is being
used.

I'm not suggesting this should be a default at all, merely an extra option
similar to selecting P4, Athlon or even -Os.

I've manually tried this flag at home with no ill effects.

Mike
