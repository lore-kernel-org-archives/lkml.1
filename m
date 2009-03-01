Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbZCAC4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbZCAC4p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 21:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbZCAC4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 21:56:37 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:43552 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbZCAC4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 21:56:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gxnJyVJnIvaqjmndxZORXHQT2iGVHVyT97v3omyuovn6uPQ5JgBS/ZTIh95vgn1WHx
         +Nl15JdYVTamTAMo7CgxSmGDvFC+fBDQnpZUyXBG4bvZ4//9KpGn7YEBcqHmErkUj+AZ
         IJeEG+OszfIvYV0x0JUfY7+T4t3f1kZ+T1Q0Q=
MIME-Version: 1.0
In-Reply-To: <49A9F597.4010601@redhat.com>
References: <49A9F597.4010601@redhat.com>
Date: Sat, 28 Feb 2009 18:56:34 -0800
X-Google-Sender-Auth: 1f9be3ef56eb0ed5
Message-ID: <86802c440902281856h1dc950e7me8568cd5dca59da9@mail.gmail.com>
Subject: Re: [PATCH] fix DMI for EFI
From: Yinghai Lu <yinghai@kernel.org>
To: Brian Maly <bmaly@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it will break dmi check for 64k ram corruption...


YH
