Return-Path: <linux-kernel-owner+w=401wt.eu-S1762466AbYFFVPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762466AbYFFVPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 17:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760798AbYFFVPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 17:15:40 -0400
Received: from web53702.mail.re2.yahoo.com ([206.190.37.23]:35587 "HELO
	web53702.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757099AbYFFVPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 17:15:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=mmA7lM++SpvygzXxvvER17OWN/k36rZTsghlL6qDCYWXp0l2F2vRCGyxOeQooZvr1An7t4lvzGSoTgYgBUH3uGxreV2U2aqjdHbaJNg2V/jQfTvrCo2H0IHxWAJuCStyqBGgy05FeA2XvHKsHhofIlTfJFn24UaqpVxg0+43m4Y=;
X-YMail-OSG: uaaLmHkVM1nrgmqMW7rK5rN8hdRhHRB23ea21ZQjsds6jO3z49yxKXTC6_aXMdkk242BOwKtmluHQ7A65IVCPJOE6D2OMGzssw--
Date: Fri, 6 Jun 2008 14:15:37 -0700 (PDT)
From: Benjamin Kidwell <benjkidwell@yahoo.com>
Subject: Re: Linux-next Alsa hda_intel events/0 high CPU usage, bisected
To: linux-kernel@vger.kernel.org
Cc: benjkidwell@yahoo.com
In-Reply-To: <442229.60477.qm@web53706.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <358659.21053.qm@web53702.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Benjamin Kidwell <benjkidwell@yahoo.com> wrote:

> according to ps. 2.6.25-rc5 does not exhibit this behavior on my machine.

That's a thinko. 2.6.26-rc5 does not exhibit the behavior. Sorry. 2.6.25.4
also does not, of course.


      
