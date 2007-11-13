Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbXKMMlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbXKMMlD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 07:41:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbXKMMkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 07:40:52 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:18043 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbXKMMkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 07:40:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=jVxajxDu9li/1lljlt5oL6yxWuMUVhyRGrnTzUU24oqkrl0QxgSfWPnn4pK0dysFZaMP8NNqUYNwCFEKAmA8JhzWt8+u7z0hawzVL8TK1AES+vM5MvjbDO2A5PbsvdaYK+jV+XXVDuXtZKmV3VDqVF2iTOES3IhvFWR7/0S8jak=
Message-ID: <47399B4D.5040208@gmail.com>
Date: Tue, 13 Nov 2007 13:40:45 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "'Sam Ravnborg'" <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: cscope build warning [Was: mm snapshot broken-out-2007-11-13-04-14.tar.gz
 uploaded]
References: <200711131215.lADCFfht009739@imap1.linux-foundation.org>
In-Reply-To: <200711131215.lADCFfht009739@imap1.linux-foundation.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2007 01:15 PM, akpm@linux-foundation.org wrote:
> The mm snapshot broken-out-2007-11-13-04-14.tar.gz has been uploaded to

$ uname -a
Linux bellona 2.6.23-rc8-mm2_64 #58 SMP Fri Sep 28 08:52:12 CEST 2007 x86_64
x86_64 x86_64 GNU/Linux
$ make O=../bu cscope
  FILELST cscope.files
find: /home/l/latest/xxx/arch/x86_64: není souborem ani adresáøem
  MAKE    cscope.out

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
