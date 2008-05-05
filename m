Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbYEEHNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbYEEHNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 03:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYEEHM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 03:12:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:35328 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbYEEHM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 03:12:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=ezH3T39EcqAAjgJ4CFD3REExTinnXOCMif91uYXaj1kmjSkT+LLzCePx1s2wtyTKOWo9HOWQNHEDb6sNZSg0E7KuIRaLUcW11Fla0ByTjdrzVCmwBDA8HMdAY//LASfi3pxJh2BSF7xjiNyBpSEWaFxwbrMCO25+rjKdaV4VIfM=
Message-ID: <30c6373b0805050012o505c0540i116a31bc1ab9ce9f@mail.gmail.com>
Date: Mon, 5 May 2008 00:12:56 -0700
From: "Kevin Burton" <burton@tailrank.com>
To: linux-kernel@vger.kernel.org
Subject: Ability to limit or disable page caching?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: dce06f858e47720f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm running into a VERY frustrating bug with page caching and swap.

I'm going to write a long post on this and forward it to the list.

In the mean time is it possible to disable the page cache or limit it
to say 10% of system memory?

I haven't found any way to do this yet.

You could do this with RHEL 4.x but I don't recall this ever making it
into 2.6 :-/

Feedback appreciated.

-- 
Founder/CEO Tailrank.com
Location: San Francisco, CA
AIM/YIM: sfburtonator
Skype: burtonator
Work: http://spinn3r.com and http://tailrank.com
Blog: http://feedblog.org
Cell: 415-637-8078
Fax: 1-415-358-419 PIN: 0092
