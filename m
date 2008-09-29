Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbYI2J3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbYI2J3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 05:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbYI2J33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 05:29:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:54814 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbYI2J32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 05:29:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lREITZYklIysm49dLNfysBRCAkL0JgqrDJd7gsgMQ1TvJvzkcT7YC7XHvYJNXqJ7us
         dS8c7lvYqSGbEdcFoIansUu28P47xsSpWvbXluWla6KKTyHol8zqfnx16HJAvydlbwJY
         VG5OpwczKae7eBNfA5cvic/daGpMFpx+DZlpQ=
Message-ID: <c62985530809290229nc5ca528o17c2547dfc0b94f8@mail.gmail.com>
Date: Mon, 29 Sep 2008 11:29:26 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [Patch -tip 1/3] Tracing/ftrace: Relay unhandled entry output
Cc: "Pekka Paalanen" <pq@iki.fi>, "Steven Rostedt" <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080927175046.GG26047@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48DB81BA.2050204@gmail.com> <20080925123802.GA6900@elte.hu>
	 <48DBA683.8000708@gmail.com>
	 <20080925180916.75d3c9ec@daedalus.pq.iki.fi>
	 <c62985530809250833x2468f07an547a82eaa1329d9@mail.gmail.com>
	 <20080925184919.016d8957@daedalus.pq.iki.fi>
	 <c62985530809250856l2c4e827cv2123b6c3c21210d7@mail.gmail.com>
	 <20080925190149.208ee3a4@daedalus.pq.iki.fi>
	 <c62985530809250940s1cdab6dau87bee24b6bc6c089@mail.gmail.com>
	 <20080927175046.GG26047@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> dont worry about that aspect too much, the ring buffer API will be a
> transparent replacement, so try to iterate whatever is there at the
> moment towards perfection :)

Ok Thanks Ingo :-)
