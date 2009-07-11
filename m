Return-Path: <linux-kernel-owner+w=401wt.eu-S1752512AbZGKGF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbZGKGF4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 02:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZGKGFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 02:05:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:3937 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbZGKGFq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 02:05:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=t/fAxCSIjK4wm2X7JB/QazfWKAt9ESchFx6AkAB1DjA4HV7iyUgtYNQrXvM3RjwqxQ
         WGuUSI4McRclIgk5xkYHvmocRajgZAsItp5cjvZz5AmKHBeiu6d7o9U8HdyPY8Rmgys3
         66UNE50MQV/HkUgWIvIbquzt1RZeerbiDYJ/o=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm/i915 fixes for 2.6.30-rc2
Date: Sat, 11 Jul 2009 08:05:42 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc2; KDE/4.2.96; x86_64; ; )
Cc: Eric Anholt <eric@anholt.net>
References: <1247263673.4678.10.camel@gaiman.anholt.net>
In-Reply-To: <1247263673.4678.10.camel@gaiman.anholt.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Message-Id: <200907110805.42273.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 of July 2009, Eric Anholt wrote:
> The following changes since commit
> c2cc49a2f8a479dde96a599646d30b6cc9dbed78: Linus Torvalds (1):
>         Merge git://git.kernel.org/.../sfrench/cifs-2.6
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel
> drm-intel-next


[   23.723011] [drm:intel_dp_i2c_init] *ERROR* i2c_init DPDDC-D


Could tihs be silenced? I don't have DisplayPort in Thinkpad t400.


-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
