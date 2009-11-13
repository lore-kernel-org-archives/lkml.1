Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbZKMR0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbZKMR0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 12:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbZKMR0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 12:26:44 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:62676 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbZKMR0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 12:26:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FY4Jc0A0wjSnB9i7sRcL0RZtcW38FrOxDZ1iX6Dcei0PkHmQ2sAKI8KFfjhHawAK3F
         3TvqBhAHSFO4YGVV0zNI6OLc8eajNu67j7trVjwPLiMeCKnldaADl0iNn3ya2dcYVvAh
         ITiv+I0KAk7mrHrWsfHH2qs1a08m3EaeYCrVg=
MIME-Version: 1.0
In-Reply-To: <81bfc67a0911130825o6d9b93b2he70677157ad889f2@mail.gmail.com>
References: <81bfc67a0911111448q2e7938fcq18adf2454d6bc8f1@mail.gmail.com>
	 <20091112113836.GA7963@ff.dom.local>
	 <81bfc67a0911120546g26627ac5q5860d85f446b29bb@mail.gmail.com>
	 <4AFC5C58.9030207@gmail.com>
	 <81bfc67a0911130825o6d9b93b2he70677157ad889f2@mail.gmail.com>
Date: Fri, 13 Nov 2009 12:21:17 -0500
Message-ID: <81bfc67a0911130921j136ec7e7m59bc47e28df5f2e@mail.gmail.com>
Subject: Re: large packet loss take2 2.6.31.x
From: Caleb Cushing <xenoterracide@gmail.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

any specific switches I should run tcpdump with? or any other tests I
should be trying while capturing? (on either end).

-- 
Caleb Cushing

http://xenoterracide.blogspot.com
