Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbYFBRrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbYFBRrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYFBRq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:46:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:62797 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbYFBRq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:46:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support
Date: Mon, 2 Jun 2008 19:42:23 +0200
User-Agent: KMail/1.9.9
Cc: hooanon05@yahoo.co.jp, Jamie Lokier <jamie@shareable.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       David Newall <davidn@davidnewall.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@lst.de
References: <200805311737.58991.arnd@arndb.de> <200806021315.41211.arnd@arndb.de> <20080602145404.GA22400@2ka.mipt.ru>
In-Reply-To: <20080602145404.GA22400@2ka.mipt.ru>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?iso-8859-1?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60?=
 =?iso-8859-1?q?Y=2Ea=5E3zb?=)
 =?iso-8859-1?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5C?=
 =?iso-8859-1?q?wg=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200806021942.24750.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/9VcLCUxIftx5GDN9ySJqEeL3mrIgZRGrpdYg
 SEK/Ns1ERh8QMTVrXFj7Fvo91O8JG3u4wah9Biy2zIALDGRYCF
 GyH56WzRweXTOoLpENVGQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 June 2008, Evgeniy Polyakov wrote:
> > I personally think that a policy other than writing to the top is crazy
> > enough, but randomly writing to multiple places is much worse, as it
> > becomes unpredictable what the file system does, not just unexpected.
> 
> Is this a double rot13 encoded "people will never use computers with
> more than 640 kb of ram" phrase? :)

No, it's more the "people don't need variable block size drives" argument.
They've been working fine for decades on mainframes, are incredibly
complicated to build and entirely pointless in practice ;-)

	Arnd <><
