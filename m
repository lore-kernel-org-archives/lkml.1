Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbXKMMvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbXKMMvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 07:51:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXKMMuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 07:50:54 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:32836 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbXKMMux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 07:50:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=g+XNHgRZc3nac+NNv/aZVh896GaUIv2DcfypLhM0Ug+RTITMEif6ah2UAB0oliD282kCpMLQcuFhzDNfnlH8h/GQzyXxM+0jpcwWLQTSdbbMlYV4EeNo+6AoGpaF8o2cOfMYBunHfwT+l/2jX5UYuWZTXl0Lsi0Ro+QT9fE9hDM=
Message-ID: <47399DA8.2060501@gmail.com>
Date: Tue, 13 Nov 2007 13:50:48 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: trond.myklebust@fys.uio.no
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: nfs functions undefined [Was: mm snapshot broken-out-2007-11-13-04-14.tar.gz
 uploaded]
References: <200711131215.lADCFfht009739@imap1.linux-foundation.org>
In-Reply-To: <200711131215.lADCFfht009739@imap1.linux-foundation.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2007 01:15 PM, akpm@linux-foundation.org wrote:
> The mm snapshot broken-out-2007-11-13-04-14.tar.gz has been uploaded to

ERROR: "nfs_put_super" [fs/nfs/nfs.ko] undefined!
ERROR: "nfs_sb_deactive" [fs/nfs/nfs.ko] undefined!
make[2]: *** [__modpost] Error 1
make[1]: *** [modules] Error 2

config:
http://www.fi.muni.cz/~xslaby/sklad/config_64

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
