Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbZAaTRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbZAaTRa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 14:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbZAaTRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 14:17:21 -0500
Received: from mail.gmx.net ([213.165.64.20]:42899 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751644AbZAaTRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 14:17:20 -0500
X-Authenticated: #10801262
X-Provags-ID: V01U2FsdGVkX1/R/R8lNXXR/bgxXAbrgIKS2xO6zNs/lrPISccyxx
	jXqK8sEF5Ng4qr
Date: Sat, 31 Jan 2009 20:17:18 +0100
From: Richard Atterer <atterer@debian.org>
To: Dmitry Torokhov <dtor@mail.ru>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 2.6.28] mousedev: Allow devices to be excluded from
	/dev/input/mice
Message-ID: <20090131191718.GA11742@arbonne.lan>
Mail-Followup-To: Dmitry Torokhov <dtor@mail.ru>,
	linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
References: <20090130120456.GA20461@arbonne.lan> <20090131042959.GA3529@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090131042959.GA3529@dtor-d630.eng.vmware.com>
Mail-Copies-To: nobody
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Fri, Jan 30, 2009 at 08:29:59PM -0800, Dmitry Torokhov wrote:
> On Friday 30 January 2009 04:04:56 Richard Atterer wrote:
> > In my case, I'm using some mice as sensors (robotic application, more 
> > or less), so their movement should not influence the mouse pointer at 
> > all.
> 
> I think this is the case where EVIOCGRAB use is warranted then.

Many thanks for the suggestion - that's exactly what I need! :-)

  Richard

-- 
  __   _
  |_) /|  Richard Atterer     |  GnuPG key: 888354F7
  | \/¯|  http://atterer.net  |  08A9 7B7D 3D13 3EF2 3D25  D157 79E6 F6DC 8883 54F7
  ¯ '` ¯
