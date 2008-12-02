Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbYLBCAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbYLBCAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 21:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbYLBCAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 21:00:45 -0500
Received: from mail-gx0-f18.google.com ([209.85.217.18]:47304 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbYLBCAo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 21:00:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=I8n+iIe+JkItVmt9VgXDNcU+j9d0RqsU2o10fUpKPGRVBeWIsB03qJq5Vr+o+kY1vQ
         pJXQWASA332Jn57VFuvehZrdoQd6eJwJ5jGPv7ieHM+fUlWAmJUVTG7a/xWcXaOn6sn8
         +oBGnnDYD4kUv/vf8xprck+wA/EjmXiBDbyVw=
Message-ID: <6540c930812011800i62ac8635y30857d71ed266bde@mail.gmail.com>
Date: Tue, 2 Dec 2008 00:00:43 -0200
From: "=?ISO-8859-1?Q?Rog=E9rio_Brito?=" <rbrito@ime.usp.br>
To: "Ivo van Doorn" <ivdoorn@gmail.com>,
       "=?ISO-8859-1?Q?Rog=E9rio_Brito?=" <rbrito@ime.usp.br>
Subject: Re: Still some problems with the rt2x00 driver
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org
In-Reply-To: <6540c930812011756x4b458d25l4ed639e79655016e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080620175729.GA3151@ime.usp.br>
	 <200808041526.08332.IvDoorn@gmail.com>
	 <3977BB08-9149-41E4-B187-235F36204E4E@ime.usp.br>
	 <200811250942.09259.IvDoorn@gmail.com>
	 <6540c930812011756x4b458d25l4ed639e79655016e@mail.gmail.com>
X-Google-Sender-Auth: 600f841a9a24bea0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again, Ivo.

On Mon, Dec 1, 2008 at 11:56 PM, Rogério Brito <rbrito@ime.usp.br> wrote:
> On Tue, Nov 25, 2008 at 6:42 AM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
>> For both cases:
>> Is there anything in the log regading the drivers or mac80211?
>
> Yes, there are. Here I reproduce the logs from both 2.6.27.x which is
> an experimental one from the Debian kernel team and the logs from a
> 2.6.28-rc6 kernel compiled by myself (with some extra debugging
> enabled).

Needless to say, if you want me to test anything else here, please let me know.


Thanks again, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
