Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbZAXDDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbZAXDDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 22:03:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbZAXDDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 22:03:44 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:3498 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbZAXDDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 22:03:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:cc
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=W2GxmMtLa+0oEQywWmGDfGyxfU5+BGWk7JdA5ovp3GZhaPw73yaJ8IBj82z5jqbB6g
         UR+kAkWLi7D6Fq++xSepVxiWTdf/V1TDT3eUksz5oaNn6eg3tFmUhs1ojO3+1Thxrptp
         4oEVDZTsuUfd9LgZm0IcS8R+zwmFVT+S53v1M=
From: Ionut Leonte <garglkml@gmail.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: How can I fix errors and warnings in nvidia module for Tesla C1060
Date: Sat, 24 Jan 2009 05:03:35 +0200
User-Agent: KMail/1.9.9
References: <3f9a31f40901222126t5baf80f8t12513dc9fd9b3f29@mail.gmail.com>
In-Reply-To: <3f9a31f40901222126t5baf80f8t12513dc9fd9b3f29@mail.gmail.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901240503.35695.ionut.leonte@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the log you attached ("Kernel messages" section):

   nvidia: module license 'NVIDIA' taints kernel.
   NVRM: No NVIDIA graphics adapter found!

Are you sure you're using the correct driver ?
